Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaCQEX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:23:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57762 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaCQEX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:23:26 -0400
Message-ID: <532678A5.4090704@zytor.com>
Date: Sun, 16 Mar 2014 21:23:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sarah Newman <srn@prgmr.com>, David Vrabel <david.vrabel@citrix.com>
CC: Suresh Siddha <sbsiddha@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>	<531DEB11.2070709@zytor.com>	<531DF319.6010800@citrix.com>	<53266841.6090308@prgmr.com>	<1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>	<53266D94.70902@prgmr.com> <53266F56.9030909@zytor.com> <5326761D.5000905@prgmr.com>
In-Reply-To: <5326761D.5000905@prgmr.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2014 09:12 PM, Sarah Newman wrote:
> 
> Unconditional eager allocation works. Can xen users count on this being included and applied to the
> stable kernels?
> 

I don't know.  If we state that it is a bug fix for Xen it might be
possible, but it would be up to Greg (Cc:'d) and the rest of the stable
team.

	-hpa

