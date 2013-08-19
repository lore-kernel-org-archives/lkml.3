Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3HSWjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:39:49 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52033 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3HSWjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:39:47 -0400
Message-ID: <1376951983.5082.18.camel@chimera>
Subject: Re: [PATCH] Fix stack corruption on some architectures
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Jan Dumon <j.dumon@option.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Aug 2013 15:39:43 -0700
In-Reply-To: <52129CD4.1060200@cogentembedded.com>
References: <1376944647.5082.12.camel@chimera>
	 <52129CD4.1060200@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 02:31 +0400, Sergei Shtylyov wrote: 
> Hello.
> 
> On 08/20/2013 12:37 AM, Daniel Gimpelevich wrote:
> 
> > There is no need to get an interface specification if we know it's the
> > wrong one; trivial change.
> 
>     Is it related to stack corruption? If not, it's asking to be in a separate 
> patch.

Perhaps, but I'll leave that up to the maintainer(s). You should be
credited as co-author of the patch.

