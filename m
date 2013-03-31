Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3CaSaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 14:30:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3CaSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 14:30:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 2/7] USB: EHCI: make ehci-spear a separate driver
Date: Sun, 31 Mar 2013 18:30:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Deepak Saxena <dsaxena@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
References: <Pine.LNX.4.44L0.1303291353210.1467-100000@iolanthe.rowland.org> <201303301203.03562.arnd@arndb.de>
In-Reply-To: <201303301203.03562.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303311830.11338.arnd@arndb.de>
X-Provags-ID: V02:K0:fbKS5fIJ2ohZzzMkgOwcCxIzk946TYc0LATEBkKRGsA
 ArdjKbOzrxmgU5reERw4R6hw1ro4PRxzol1q8X2wcHoelgnZge
 b1Z+snFB7+isZ9YG1s7bil0WzFNw3YWt2pUUaOdIH+SJExmZAC
 DKj+VoRWRPAifMqudDqMhkfQSbfzuBLc8K0vLFbA9mX8xrpDiD
 Ocpil4dA0x343wIBvjty2Y9mhCKkz/pr/BqPjHbqljsr9GO2Bf
 HT4HEKCfP61u0aVYTwXYtoVRfolW1sZovxfG3FO4nEaTP4qdtl
 RmReX6p6+ssFeDTqfzY8UFKhcYUtkxLwDCrU+atnj/bfNv7qL6
 o7QWL16q514OVw0lxzJM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 March 2013, Arnd Bergmann wrote:
> > > In V3:
> > >  -Detailed commit message added here about why this patch is required.
> > >  -Eliminated ehci_spear_setup routine beacuse hcd registers
> > >   directly setting in spear_ehci_hcd_drv_probe function.
> > 
> > Fix the grammar, please.
> 
> Done. I agree some of this is hardly legible.
> 

I realized later that the other patches have similarly screwed up
changelogs. I'll send a new version once you've commented on v4,
so in case there is anything else I missed I'm not spamming everyone
another time.

	Arnd
