Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbbAFWop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:44:45 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:58710 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbAFWon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:44:43 -0500
Message-ID: <1420584282.6927.62.camel@haakon3.risingtidesystems.com>
Subject: Re: [target:nvme_of 3/3]
 drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol
 'nvme_of_fabric_configfs' was not declared. Should it be static?
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 06 Jan 2015 14:44:42 -0800
In-Reply-To: <201501070334.EgwC5iey%fengguang.wu@intel.com>
References: <201501070334.EgwC5iey%fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 03:35 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git nvme_of
> head:   40d8c11927282d59855d645b35798edd97828da5
> commit: 40d8c11927282d59855d645b35798edd97828da5 [3/3] nvme_of: Initial skeleton commit
> reproduce:
>   # apt-get install sparse
>   git checkout 40d8c11927282d59855d645b35798edd97828da5
>   make ARCH=x86_64 allmodconfig
>   make C=1 CF=-D__CHECK_ENDIAN__
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?
> 
> Please review and possibly fold the followup patch.
> 

Fixed.  Thanks Fengguang!

--nab

