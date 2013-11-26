Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3KZFvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 00:51:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:6064 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab3KZFvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 00:51:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,772,1378882800"; 
   d="scan'208";a="414878552"
Message-ID: <52943422.1090402@intel.com>
Date: Tue, 26 Nov 2013 13:39:46 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Chang Liu <cl91tp@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, Jility <jility09@gmail.com>,
        Florian Otti <f.otti@gmx.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: add a quirk for keeping Bus Master bit on shutdown
References: <1384285203-642-1-git-send-email-cl91tp@gmail.com> <CAErSpo5E4584zgTt4ySPSEFhtwdHDOyrrowirp=SmtmJjDyHgg@mail.gmail.com>
In-Reply-To: <CAErSpo5E4584zgTt4ySPSEFhtwdHDOyrrowirp=SmtmJjDyHgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年11月26日 11:33, Bjorn Helgaas wrote:
> Lan, do you have access to any Lynx Point boxes?  Can you test and see
> whether they hang on power-off also?  I suspect this might be something
> specific to the Acer box, not a generic Lynx Point issue.

Sure. I just get one such prototype laptop and power off works normally
on it.

-- 
Best regards
Tianyu Lan
