Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBCPW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:22:56 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39505 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaBCPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:22:54 -0500
Message-ID: <52EFB447.2080608@linux.vnet.ibm.com>
Date: Mon, 03 Feb 2014 09:22:47 -0600
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/2] ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
References: <cover.1389904166.git.agordeev@redhat.com> <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com> <20140128095441.GA6951@dhcp-26-207.brq.redhat.com> <52E7CCAD.5070008@linux.vnet.ibm.com> <20140129132651.GA27764@dhcp-26-207.brq.redhat.com> <20140130140630.GA32349@dhcp-26-207.brq.redhat.com> <20140130141031.GC32349@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140130141031.GC32349@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020315-9332-0000-0000-000002F983A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


