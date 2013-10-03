Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3JCLvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:51:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43806 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3JCLvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:51:32 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-0e-524d5a43ad59
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/legacy_serial: fix incorrect placement of
 __initdata tag
Date: Thu, 03 Oct 2013 13:51:27 +0200
Message-id: <1600459.LJx7sBeEJs@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20131001061325.GD17966@concordia>
References: <35419229.o6Cv8JYbpg@amdc1032> <20131001061325.GD17966@concordia>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQV3nKN8gg5tnhSw+NLUyW5xtesNu
	cXnXHDaL39//sVpcnrSSyWLNkcXsDmwei142sHj0vGlh9Tg/YyGjx9xdfYwefVtWMXp83iQX
	wBbFZZOSmpNZllqkb5fAlfFp5x+2glWsFa/XzGJuYFzO0sXIySEhYCIxZdM0ZghbTOLCvfVs
	XYxcHEIC0xklNmw/DeW0MEnsmbCVCaSKTcBKYmL7KkYQW0RAV+LdpatgRcwCRxgl7r46ygaS
	EBYIl3j16gXYChYBVYlpvy+zg9i8ApoSzSc+gtmiAp4SnyYtBVvNKaAv8XfLf7B6IQFfia8H
	F7NB1AtK/Jh8DyzOLCAvsW//VFYIW0ti/c7jTBMYBWYhKZuFpGwWkrIFjMyrGEVTC5ILipPS
	c430ihNzi0vz0vWS83M3MYID/Zn0DsZVDRaHGAU4GJV4eDtUfIKEWBPLiitzDzFKcDArifBe
	C/INEuJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cBodLxp
	QrOaonJBN8u0OaWlSZP2B6VnNT5Wiai0Wf5m+wHmE+Iy6yVkjuQwaN+Zepo1ViZ8xu1j2x85
	HOSZE9zkOWm6K39XlPJbu0dlv76lT2riOS0i3ZSbkTDjG/OEg88Xr3K6LP/lol3IH9aNqtdU
	8k+FRPr9bEmefPfJRkk7TgVpsymzxR2UWIozEg21mIuKEwFT/kfxcAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 01, 2013 04:13:25 PM Michael Ellerman wrote:
> On Mon, Sep 30, 2013 at 03:11:42PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > __initdata tag should be placed between the variable name and equal
> > sign for the variable to be placed in the intended .init.data section.
> 
> I see lots of other occurences of that in arch/powerpc. Why not send a
> single patch to update them all?

The other occurences while not following the preferred kernel coding style
are (probably) working OK with gcc. This particular occurence just doesn't
work as it should.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

