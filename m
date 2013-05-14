Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3ENGeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:34:36 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49894 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3ENGee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:34:34 -0400
Date: Tue, 14 May 2013 01:34:31 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] hibernate: Correct documentation
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        =?iso-8859-1?b?Qmr4cm4=?= Mork <bjorn@mork.no>
References: <136862945.66DBfZPmr6@vostro.rjw.lan>
	<1368446403-4896-1-git-send-email-bp@alien8.de>
In-Reply-To: <1368446403-4896-1-git-send-email-bp@alien8.de> (from
	bp@alien8.de on Mon May 13 07:00:03 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1368513271.18069.235@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 07:00:03 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Correct the meaning of PM_HIBERNATION_PREPARE in the docs, as per
> Rafael.
> 
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Bjørn Mork <bjorn@mork.no>
> Link: http://lkml.kernel.org/r/20130512162717.GA6305@pd.tnic
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  Documentation/power/notifiers.txt | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/power/notifiers.txt  
> b/Documentation/power/notifiers.txt
> index c2a4a346c0d9..a81fa254303d 100644
> --- a/Documentation/power/notifiers.txt
> +++ b/Documentation/power/notifiers.txt
> @@ -15,8 +15,10 @@ A suspend/hibernation notifier may be used for  
> this purpose.
>  The subsystems or drivers having such needs can register suspend  
> notifiers that
>  will be called upon the following events by the PM core:
> 
> -PM_HIBERNATION_PREPARE	The system is going to hibernate or  
> suspend, tasks will
> -			be frozen immediately.
> +PM_HIBERNATION_PREPARE	The system is going to hibernate, tasks  
> will be frozen
> +			immediately. This is different from  
> PM_SUSPEND_PREPARE
> +			below because here we do additional work  
> between notifiers
> +			and drivers freezing.

Additional work such as...?

Rob