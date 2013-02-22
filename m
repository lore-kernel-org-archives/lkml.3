Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3BVPqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:46:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43623 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab3BVPqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:46:50 -0500
Date: Fri, 22 Feb 2013 10:46:45 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: JBeulich@suse.com
Subject: Put git commit 51ac8893a7a51b196501164e645583bf78138699 on the
 stable tree please
Message-ID: <20130222154644.GB8809@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

Please put git commit 51ac8893a7a51b196501164e645583bf78138699
commit 51ac8893a7a51b196501164e645583bf78138699
Author: Jan Beulich <jbeulich@suse.com>
Date:   Wed Feb 6 10:30:38 2013 -0500

    xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()

on the stable tree please. It is an security errata fix and should
have had the CC: stable@vger.kernel.org but did not.
