Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbbASNtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:49:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbbASNtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:49:46 -0500
Date: Mon, 19 Jan 2015 08:49:42 -0500
From: Don Zickus <dzickus@redhat.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: Uhhuh - Dazed and confused, but trying to continue  :)
Message-ID: <20150119134942.GH116159@redhat.com>
References: <54BB8FFE.5010308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BB8FFE.5010308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 11:50:38AM +0100, poma wrote:
> 
> Salutem
> 
> This happened only on thaw from S4 aka hibernate.
> What should be "strange power saving mode" these messages relate!?
> 
> [  208.252986] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> [  208.252991] Do you have a strange power saving mode enabled?
> [  208.252992] Dazed and confused, but trying to continue
> 
> 3.18.3-200.fc21.x86_64

This looks to be an external unknown NMI (unless you can reproduce on
something other than cpu0).

I would have to know what hardware you have and see the dmesg log after
the resume from hibernate.

You can open a bz and assign it to me.

Just attach the dmesg log, lspci and lspci -t output to the bz.

Though this is most likely a pci device firmware problem.  But I can try
to narrow it down.

Cheers,
Don
