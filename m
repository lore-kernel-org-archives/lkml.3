Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaGHSRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:17:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:31579 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbaGHSRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:17:37 -0400
X-IronPort-AV: E=Sophos;i="5.01,626,1400025600"; 
   d="scan'208";a="150681605"
Message-ID: <53BC35BE.5040605@citrix.com>
Date: Tue, 8 Jul 2014 19:17:34 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v3 4/7] xen/pciback: Implement PCI reset slot
 or bus with 'do_flr' SysFS attribute
References: <1404845909-13563-1-git-send-email-konrad@kernel.org> <1404845909-13563-5-git-send-email-konrad@kernel.org>
In-Reply-To: <1404845909-13563-5-git-send-email-konrad@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.18]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 19:58, konrad@kernel.org wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> The life-cycle of a PCI device in Xen pciback is complex
> and is constrained by the PCI generic locking mechanism.
>
> It starts with the device being binded to us - for which

"being bound to us"

~Andrew
