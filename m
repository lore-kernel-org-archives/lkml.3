Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3KULR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:17:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51795 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3KULRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:17:54 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-08-528debdbc557
From: Jingoo Han <jg1.han@samsung.com>
To: "'Borislav Petkov'" <bp@alien8.de>,
        "'Francis Moreau'" <francis.moro@gmail.com>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <20131117195358.GO27323@pd.tnic>
 <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com>
 <20131117220611.GQ27323@pd.tnic> <528A05D0.30907@gmail.com>
 <20131118133210.GG24851@pd.tnic> <528B36EA.20301@gmail.com>
 <20131119101521.GA3515@pd.tnic> <528C84A1.5030707@gmail.com>
 <20131120111541.GA30147@pd.tnic> <528DC2AA.4070202@gmail.com>
 <20131121101234.GB25459@pd.tnic>
In-reply-to: <20131121101234.GB25459@pd.tnic>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Date: Thu, 21 Nov 2013 20:17:47 +0900
Message-id: <000801cee6ab$4e9f9380$ebdeba80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7mojgQZsd0KbyeSx+9+m8DXUMWtQAA7QnQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zfd3br3uDDLb8UbH4vOEfm8X21xvZ
	LF72/WG1uLzwEpDYNYfNon9hL5PF6W5Wi82bpjJbrFx3ms2B0+N7ax+Lx85Zd9k9Dl1Zy+jx
	7tw5do95JwM9fmx4x+jRt2UVo8ejxS2MHp83yQVwRnHZpKTmZJalFunbJXBltLw5y1ywWKCi
	41lEA+Njni5GTg4JAROJjU+bWCBsMYkL99azgdhCAssYJfYd14apab2zk7WLkQsovohR4v/X
	LYwQzi9GiXc7NrODVLEJqEl8+XIYzBYRKJe40PyPCaSIWeA5o0TzulVQHROZJbY1b2YGqeIU
	0JW4fbcBrENYwEvi7a1ZYDaLgKrEpWP9TCA2r4CtxMGWH+wQtqDEj8n3gG7lAJqqLjFlSi5I
	mFlAXmLzmrfMIGEJoPCjv7oQNxhJTJr5lR2iRERi34t3YCdICEzlkHi29zULxCoBiW+TD7FA
	9MpKbDrADPGxpMTBFTdYJjBKzEKyeBbC4llIFs9CsmEBI8sqRtHUguSC4qT0IkO94sTc4tK8
	dL3k/NxNjJCY793BePuA9SHGZKDtE5mlRJPzgSkjryTe0NjMyMLUxNTYyNzSjDRhJXHepIdJ
	QUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYM1PWKGV5WgUFZmr1GzQKKD69Lyv76NDaMPnO
	TTLWTe93iL9Z8WaJwpIXl57MefO9+ObtggKxo9OO913X3dBQ/z9YofhZwK7gdSu8lssZ8Ajv
	8lmUr2+WVMyd2n/Q6/enTVsv//9WzBh69je71rUZBz3ilyyoOnO8e2HE9le/n756o71wViXf
	aSWW4oxEQy3mouJEAE2FPi4PAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jAd3br3uDDDZclLf4vOEfm8X21xvZ
	LF72/WG1uLzwEpDYNYfNon9hL5PF6W5Wi82bpjJbrFx3ms2B0+N7ax+Lx85Zd9k9Dl1Zy+jx
	7tw5do95JwM9fmx4x+jRt2UVo8ejxS2MHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA3aikUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxjzGh5c5a5YLFARceziAbGxzxdjJwcEgImEq13drJC2GISF+6tZ+ti5OIQ
	EljEKPH/6xZGCOcXo8S7HZvZQarYBNQkvnw5DGaLCJRLXGj+xwRSxCzwnFGied0qqI6JzBLb
	mjczg1RxCuhK3L7bANYhLOAl8fbWLDCbRUBV4tKxfiYQm1fAVuJgyw92CFtQ4sfkeyxdjBxA
	U9UlpkzJBQkzC8hLbF7zlhkkLAEUfvRXF+IGI4lJM7+yQ5SISOx78Y5xAqPQLCSDZiEMmoVk
	0CwkHQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKeUZ1I7GFc2WBxiFOBgVOLh7Xjc
	EyTEmlhWXJl7iFGCg1lJhPfV894gId6UxMqq1KL8+KLSnNTiQ4zJQG9OZJYSTc4Hpru8knhD
	YxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDs1D5StnznotopN63u
	8k3YuVDQ9XXi79UKEgxxD5Q/8+rflUnZ+jzn4pk1gXPD1mibf1gvmOlckWH2KI1f5NdHlb0n
	395dNbXhbs4O9wwH6VVVR+Yf6TcTcklYxfPmYd6srj1JEQrsvWe5k6577I75Hxjqy6xmEnli
	d8ahPzOqVVMOCqs9yFypxFKckWioxVxUnAgAdcE26G0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 21, 2013 7:13 PM, Borislav Petkov wrote:
> On Thu, Nov 21, 2013 at 09:22:02AM +0100, Francis Moreau wrote:
> > Hmm, I think it's more than that because if I'm removing both
> > rtsx_pci_ms and memstick modules, then suspending and resuming doesn't
> > oops anymore.
> 
> Interesting - so this is a good datapoint. Sounds like those modules
> can't stomach suspend-to-ram. So let's add a couple more people for
> comment.

Thank you for inviting me. :-)
It is very interesting.

> 
> To the newly-CCed, guys, thread starts here:
> 
> http://marc.info/?l=linux-kernel&m=138468134321335
> 
> > Also I took a look at the changes between v3.11 and v3.12 in this area
> > and those changes match the issue I'm facing:
> >
> > $ git log --oneline v3.11..v3.12 -- drivers/mfd/rtsx_pcr.c
> > 09fd867 mfd: rtsx: Copyright modifications
> > eb891c6 mfd: rtsx: Configure to enter a deeper power-saving mode in S3
> > 7140812 mfd: rtsx: Move some actions from rtsx_pci_init_hw to individual
> > extra_init_hw
> > 5947c16 mfd: rtsx: Add shutdown callback in rtsx_pci_driver
> > 773ccdf mfd: rtsx: Read vendor setting from config space

In my opinion, rtsx_pci_resume()/rtsx_pci_suspend() in realtek PCIe card
reader driver may make the kernel panic.

I think that the commit "mfd: rtsx: Configure to enter a deeper
power-saving mode in S3" may be the culprit.

Francis Moreau,
Let us know the exact model name of rts52xx PCIe card reader
in your laptop? According to the commit, Wei WANG added S3 mode
to rts5227 driver ,and rts5249 driver.

Wei Wang,
Would you confirm that the S3 mode works properly in rts52xx PCIe
card reader devices?

Best regards,
Jingoo Han

> >
> > I'll try to bisect one more time those changes tonight to see if I can
> > find out if one of those commits is the culprit.
> 
> Good idea.
> 
> > Sorry for not answering the first time, but yes my bios is uptodate.
> 
> Ok, good.
> 
> --
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --

