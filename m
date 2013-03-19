Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3CSKJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:09:47 -0400
Received: from storage.astrosoft.ru ([195.218.158.6]:46683 "HELO
	storage.astrosoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751371Ab3CSKJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:09:45 -0400
From: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Mar 2013 14:09:38 +0400
Subject: RE: [PATCH 1/1] Add a new platform tree for ib8315. Also add the
 DTS and the defconfig for that board.
Thread-Topic: [PATCH 1/1] Add a new platform tree for ib8315. Also add the
 DTS and the defconfig for that board.
Thread-Index: Ac4kFcAdpAQqDRxgRjW4Umu6oD1+VgAc0jXQ
Message-ID: <94EB659E3D5E594D80696B67540292A2F6D13719A1@nov-exch01.astro.local>
References: <1363614452-1109-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
 <307780DE-9735-4329-B5D7-DF2E9451A217@kernel.crashing.org>
In-Reply-To: <307780DE-9735-4329-B5D7-DF2E9451A217@kernel.crashing.org>
Accept-Language: ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ru-RU
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Mar 2013 10:09:43.0092 (UTC) FILETIME=[E0339740:01CE2489]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. Ib8315 based on tqm8315. Ib8315 is baseboard that has the tqm8215m plugged in as "the central part". 

-----Original Message-----
From: Kumar Gala [mailto:galak@kernel.crashing.org] 
Sent: 19 марта 2013 г. 00:18
To: Sergey Gerasimov
Cc: Benjamin Herrenschmidt; Paul Mackerras; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Add a new platform tree for ib8315. Also add the DTS and the defconfig for that board.


On Mar 18, 2013, at 8:47 AM, Sergey Gerasimov wrote:

> Signed-off-by: Sergey Gerasimov 
> <Sergey.Gerasimov@astrosoft-development.com>
> ---
> arch/powerpc/boot/dts/ib8315.dts           |  490 +++++++
> arch/powerpc/configs/83xx/ib8315_defconfig | 2121 ++++++++++++++++++++++++++++
> arch/powerpc/platforms/83xx/Kconfig        |    7 +
> arch/powerpc/platforms/83xx/Makefile       |    1 +
> arch/powerpc/platforms/83xx/tqm8315.c      |  137 ++
> 5 files changed, 2756 insertions(+)
> create mode 100644 arch/powerpc/boot/dts/ib8315.dts create mode 100644 
> arch/powerpc/configs/83xx/ib8315_defconfig
> create mode 100644 arch/powerpc/platforms/83xx/tqm8315.c

Is there some relationship of this board with the TQM8315?

- k
