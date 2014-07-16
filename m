Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbaGPAxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:53:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37979 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbaGPAxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:53:11 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-05-53c5ccf5d2f6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org,
        "=?ISO-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>,
        "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <1404496099-26708-14-git-send-email-t.figa@samsung.com>
 <53C5BF24.9030302@samsung.com>
In-reply-to: <53C5BF24.9030302@samsung.com>
Subject: RE: [PATCH 13/19] ARM: s5pv210: move debug-macro.S into the common
 space
Date: Wed, 16 Jul 2014 09:53:11 +0900
Message-id: <046101cfa090$51757260$f4605720$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFp3eVipvgYGaNqEQJQzJSPj11OIgLMolGIAdCoUDucSHnQgA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zge7XM0eDDbZME7H4O+kYu8XUh0/Y
	LP4/es1qsenxNVaLy7vmsFnMOL+PyWLtkbvsFqeuf2azWD/jNYvFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CVsfryJKaC
	WZwVD7onMjcwLmPvYuTkkBAwkdi+YgErhC0mceHeejYQW0hgGaPEzM9JMDVLdtwHqucCik9n
	lOhvnAfl/GWU2DLvMjNIFZuAhsTh98/ApooIqEn83v8NrIhZ4BmTxNeD21ggOuYySjzoWwi2
	g1NAW+Jd7zqw3cICwRKvr95nAbFZBFQl/k/bBGbzClhK/OvYAWULSvyYfA/MZhbQkdjfOo0N
	wpaX2LzmLTPErQoSO86+ZoS4wkni+eTpTBA1IhL7XrxjBDlCQmAih0T359WsEMsEJL5NPgQ0
	lAMoISux6QDUHEmJgytusExglJiFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0otM9YoTc4tL
	89L1kvNzNzFCon/iDsb7B6wPMSYDrZ/ILCWanA9MHnkl8YbGZkYWpiamxkbmlmakCSuJ86Y/
	SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJi6p6Gfz3u2n7JS+CxjztWHFSQEc7tOlUvs
	zL62JPm8Q1C3gd2mZy57z0luy1nw7YvfnOXl6nOcPKI3Zym/Llx5bjLDyvlTXQtPl218fcfu
	p7D79/x9X492/Uut2srqJf6nyvfce7ftsi13o6M+C3vpL5F9tbbYtluI89rtzIJLb4uXWJqL
	RSixFGckGmoxFxUnAgCao8gbFAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd2vZ44GG7x8y2/xd9IxdoupD5+w
	Wfx/9JrVYtPja6wWl3fNYbOYcX4fk8XaI3fZLU5d/8xmsX7GaxaLVbv+MDpwefz+NYnRY+es
	u+wem1Z1snlsXlLvceVEE6tH35ZVjB7br81j9vi8SS6AI6qB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EglhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bqy5OYCmZxVjzonsjcwLiMvYuRk0NCwERiyY77ULaYxIV769m6
	GLk4hASmM0r0N85jh3D+MkpsmXeZGaSKTUBD4vD7Z2AdIgJqEr/3fwMrYhZ4xiTx9eA2FoiO
	uYwSD/oWsoFUcQpoS7zrXccKYgsLBEu8vnqfBcRmEVCV+D9tE5jNK2Ap8a9jB5QtKPFj8j0w
	m1lAR2J/6zQ2CFteYvOat8wQtypI7Dj7mhHiCieJ55OnM0HUiEjse/GOcQKj0Cwko2YhGTUL
	yahZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOLs+kdzCuarA4xCjAwajEw7sh
	5GiwEGtiWXFl7iFGCQ5mJRHeH2uBQrwpiZVVqUX58UWlOanFhxhNgT6dyCwlmpwPTHx5JfGG
	xiZmRpZGZhZGJubmSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoYlywQFT1w3vHRbZvIN6uK
	YnRvz0x6mv8o7Zp3ifYB9ndp4axq/p2zOK2VetV2n4v9MV38wXchxpoXNirBhfcuXitZMCc3
	LzisKMbo6q9d5jZrT20ve26g73WwsO23Xax2vYQy57Xfj9iniqi1T5/1WsTcMHdR5xPnXSeZ
	ZoTsVci54Ci4/v0WJZbijERDLeai4kQAI+ScEkQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> On 07/05/14 02:48, Tomasz Figa wrote:
> > Move debug-macro.S from mach/include to include/debug where
> > all other common debug macros are.
> >
> > Signed-off-by: Tomasz Figa<t.figa@samsung.com>
> > ---
> >   arch/arm/Kconfig.debug                           | 12 +++++--
> >   arch/arm/include/debug/s5pv210.S                 | 34 ++++++++++++++++++++
> >   arch/arm/mach-s5pv210/include/mach/debug-macro.S | 41 ------------------------
> >   3 files changed, 44 insertions(+), 43 deletions(-)
> >   create mode 100644 arch/arm/include/debug/s5pv210.S
> >   delete mode 100644 arch/arm/mach-s5pv210/include/mach/debug-macro.S

[...]

> Tomasz,
> 
> I couldn't apply this one from this your series because of conflict with
> others. Can you please respin this one?
> 
One more note, since I didn't apply this, there is a build breakage for
s5pv210_defconfig now...

arch/arm/kernel/debug.S:24:33: fatal error: mach/debug-macro.S: No such file or directory
compilation terminated.
make[2]: *** [arch/arm/kernel/debug.o] Error 1
make[1]: *** [arch/arm/kernel] Error 2
make[1]: *** Waiting for unfinished jobs....

- Kukjin

