Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaDPTnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:43:45 -0400
Received: from mxip4-inbound.gatech.edu ([130.207.182.13]:49522 "EHLO
	mxip4-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDPTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:43:43 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 15:43:43 EDT
X-RemoteIP: 130.207.185.163
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 79231825
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.97,873,1389762000"; 
   d="scan'208";a="79231825"
X-GT-Spam-Rating: (0%)
Message-ID: <534EDCC7.1040701@gatech.edu>
Date: Wed, 16 Apr 2014 15:40:55 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/torture.c: unmark torture_init_*  as __inline
References: <534EDBF4.6030702@gatech.edu>
In-Reply-To: <534EDBF4.6030702@gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject should be: 

[PATCH 1/1] kernel/torture.c: unmark torture_init_begin/end as __init


