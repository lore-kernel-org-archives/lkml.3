Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3EaMUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:20:32 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53662 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab3EaMUZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Fri, 31 May 2013 08:20:25 -0400
Message-Id: <51A8B1B802000078000DA0A0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 31 May 2013 13:20:40 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Wei Yongjun" <weiyj.lk@gmail.com>, <konrad.wilk@oracle.com>
Cc: <jeremy@goop.org>, <gregkh@linuxfoundation.org>,
        <virtualization@lists.linux-foundation.org>,
        "xen-devel" <xen-devel@lists.xen.org>, <jkosina@suse.cz>,
        <yongjun_wei@trendmicro.com.cn>, <linux-kernel@vger.kernel.org>,
        <shemminger@vyatta.com>
Subject: Re: [PATCH] xen-pciback: fix error return code in
 pcistub_irq_handler_switch()
References: <CAPgLHd89ByaKLsvu=C-im9cg=7X7jNANuS+BaHt_EGotc-8hmA@mail.gmail.com>
In-Reply-To: <CAPgLHd89ByaKLsvu=C-im9cg=7X7jNANuS+BaHt_EGotc-8hmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 31.05.13 at 13:59, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOENT in the pcistub_device_find() and pci_get_drvdata()
> error handling case instead of 0(overwrite to 0 by str_to_slot()), as done
> elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Jan Beulich <jbeulich@suse.com>

