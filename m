Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaKJOeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:34:12 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60591 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbaKJOeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:34:10 -0500
Message-Id: <1415630049.1093092.189178905.71C55FFE@webmail.messagingengine.com>
X-Sasl-Enc: 57dLlHku8MyLiDZAaJru0CTV85MEF8nVdVIlnWIKp7Nf 1415630049
From: Martin Tournoij <martin@arp242.net>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-9183bd94
Subject: Re: [RFC] The SIGINFO signal from BSD
Date: Mon, 10 Nov 2014 15:34:09 +0100
In-Reply-To: <20141110142200.676b5d04@alan.etchedpixels.co.uk>
References: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com>
 <545A7B00.1040309@gmail.com> <20141105201404.GH27083@thunk.org>
 <20141110142200.676b5d04@alan.etchedpixels.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014, at 15:22, One Thousand Gnomes wrote:
> > wouldn't be accepted.  (BTW, if you're going to do this, note that ^T
> > could be remapped to any control character via stty; so to do this we
> > would need to define an extra index in c_cc[] array in the struct
> > termios.)
> 
> We have 19 entries in the array and no platforms that byte pack so that
> would actually be doable I think.
> 
> I'm really dubious about its value in the Linux world. You could do far
> better teaching the GUI desktop to walk the process tree of clients and
> dump the window owners process subtrees in a nice pop up window.

I don't use a GUI desktop, and almost none of my programmer friends do.
