Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaBQT3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:29:35 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50768 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaBQT3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:29:33 -0500
Date: Mon, 17 Feb 2014 11:29:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V2] ONKEY: da9052: Use correct register bit for key status
Message-ID: <20140217192927.GD19223@core.coreip.homeip.net>
References: <201402121518.s1CFIkDP009092@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402121518.s1CFIkDP009092@swsrvapps-02.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 02:11:34PM +0000, Anthony Olech wrote:
> The wrong register bit of the DA9052/3 PMIC registers was
> used to determine the status on the ONKEY.
> 
> Also a failure in reading the status register will no longer
> result in the work queue being rescheduled as that would result
> in a (potentially) endless retry.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Acked-by: David Dajun Chen <david.chen@diasemi.com>

Applied, thank you.

-- 
Dmitry
