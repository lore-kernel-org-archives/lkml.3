Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaI3PP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:15:58 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57006 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaI3PP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:15:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Rob Herring <robh@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/pci: add pci_pio_to_address dummy for !CONFIG_OF
Date: Tue, 30 Sep 2014 17:15:19 +0200
Message-ID: <2033939.5UfzeSiRKs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930144506.GQ841@e106497-lin.cambridge.arm.com>
References: <706416181.hbVGLDA3o6@wuerfel> <20140930144506.GQ841@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:M1QbgegQd2UkSwTYxl1EUFurThpZVzN6RgogBCDSzW6
 oaeFU2U8kkxqsePpwVJshuBCrfE3J/vM0VdZZyh6Xd4aKBhk2E
 84f60t2eCSSnv9sOKbNSgw5618E9vqf8mbvQdp0cHxcXgqQV5U
 35TfLsrCsizEBVEUhTn5Qle2oWD/xo/maQghuIbx26ctsR4xpA
 oHHXWSg7NE5s3dyl7KCCxFc9VozPY2QrqwYt2XKkH7qdRS+RMg
 9Y0EAeqvheWMTAkk+2XEik7HUihibauOYkcc+RJ91BUwjDiaRy
 Ui2gRYnMHQ/XIqW2ImPxlY/k1E9g/SRCo8wz9KEzpqbwr/aE0O
 skfOyzWLQglMstv20jds=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 15:45:06 Liviu Dudau wrote:
> 
> Acked-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> Is that triggered by shmobile_defconfig?
> 
> 

No, I only found it using randconfig testing, shmobile enables CONFIG_OF by
default.

	Arnd
