Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab3LWTPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 14:15:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47361 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab3LWTPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 14:15:24 -0500
Message-ID: <52B88BB9.3070808@zytor.com>
Date: Mon, 23 Dec 2013 11:15:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexey Gladkov <gladkov.alexey@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: VT Improvements
References: <52B83457.8080907@gmail.com>
In-Reply-To: <52B83457.8080907@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 05:02 AM, Alexey Gladkov wrote:
> Greetings!
> 
> I would like to know about the VT plans. Historically, keymap
> implementations are similar in the kernel and kbd project. I rewrote
> it in kbd. So, it can handle keycodes bigger than 255. In a kernel
> everything remained as before. I want to fix this part in a kernel. As
> pluses will be:
> 
> * opportunity to define keycode > 255.
> * opportunity to reduce this table a kernel in most cases.
> 
> I would like to ask your opinion about my plans because I heard about
> the thought of moving this functionality to user space.
> 
> Whether it is worth starting so large-scale changes?
> 

What I don't think we want to do is to make the current VT
implementation in the kernel significantly bigger.  That is why
proposals to introduce bidirectionality or character shaping generally
have not been accepted.  If you can improve functionality with a
*smaller* footprint, which you seem to imply above, then please, go ahead.

	-hpa

