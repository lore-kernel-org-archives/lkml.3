Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3C3M4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:56:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3C3M4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:56:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 7/7] USB: OHCI: avoid conflicting platform drivers
Date: Sat, 30 Mar 2013 12:56:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.1303291612370.1467-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303291612370.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303301256.19027.arnd@arndb.de>
X-Provags-ID: V02:K0:JafgTdnucqHi01sFXXO4dNTKW/eJkrBf2k72pz6I2T3
 1pae5HYJ9krhpVQ627/iDyu+CkRyjZqcMxuxc9fBYfJW3igEhp
 HGHqu89P+HghI5vpu/DyfwyBCrCU2CLVv7zZzBKR2Yq73o5d7f
 7Hu3zxJw768fCuf775dycM3ZTII8V2RVYfcH+bXO+CRGhn7k1Q
 af5r3A6iYZ4X84De7D7ACIYALWSDcnHtbnNXx5oxtDxz+yKM7X
 krBMsxKkdY/N3V1C1OzpU/JSVofZpK/fjv6v6q52VanfmPZvD4
 BrvCba+tICfiATEY9L5mHf0LSzEuicbbfNGMERvq41g9POXpaO
 KnOXiMWFk94GExdlmUx4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 March 2013, Alan Stern wrote:
> I have not checked the details of all the changes; however, the basic
> idea is okay as a stop-gap measure.

Ok, thanks. 

> I guess this means the onus is now on me to split up ohci-hcd into a 
> central library and separate bus drivers, like ehci-hcd...

The original plan in my teams was that Manjunath would do that after
he was done with the simple conversion of the EHCI drivers. I think we
can all agree now that it's better if you at least the groundwork instead.

Please let us know if you would like Manjunath to continue with splitting
out the OHCI back-ends into separate drivers, or if you think that there
is no point given the quality of the earlier patches.

	Arnd
