Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaJUJPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:15:38 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49639 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaJUJPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:15:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Srikanth Vemula <svemula@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine driver support
Date: Tue, 21 Oct 2014 11:14:55 +0200
Message-ID: <3236720.MHeqOodrCV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <ff137744d6474640aab09e5d6f62921a@BN1AFFO11FD019.protection.gbl>
References: <1413374436-14410-1-git-send-email-sthokal@xilinx.com> <4301925.4pMHXMXqA4@wuerfel> <ff137744d6474640aab09e5d6f62921a@BN1AFFO11FD019.protection.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:EgZxNjhgXnld+9OEaJnptn10qFMSDiFvZ9cyKHWiU3S
 fmgKcDEiBayYXiBrAHPBFuSN7RSm40FUIliXv9hmvCUKbWKf4H
 tQl7LhJ66K9Jz/3JweQZSsTvT8+/ZyYkfmvAZrIeL+Ggh73tbF
 CyTT7e6utiKa3/KV2g8IemHVBYgEk+0O4a3rBgCi1pbG+RMKMz
 UczQOO3XTfUhjApWpCgdhOJVK49+k9KSU/JCcfugs1kQh02cJx
 xvZsb+TDmikQSwgEdrgI39f20FvtjlSNCVn+bhjfz83VY7U/TH
 /rzPe79ZiM/ujUIHRrQWigpacWqL1ZDeZLUo4fX+Y3rj5OUGk5
 edg5FhGFchZKOxk4IKWY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 09:06:13 Appana Durga Kedareswara Rao wrote:
> The above mentioned API's  and structures will be used by the dma test
> client driver's to set hardware configuration information. The dma
> client drivers are not mainlined  yet and it is
> Internally used by  our git-tree  to test the DMA functionality in loopback .

I would suggest you add the test driver into the main dmaengine driver
file directly then, so you don't need to export the symbols. If there
are important reasons to keep that as separate files, just move the
header to the drivers/dma/ directory and add the test driver there.

	Arnd 

