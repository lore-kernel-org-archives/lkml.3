Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbaGXSvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:51:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:17008 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759701AbaGXSvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:51:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,725,1400050800"; 
   d="scan'208";a="574984936"
Message-ID: <1406227874.2874.3.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH v8 00/22] Support ext4 on NV-DIMMs
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Boaz Harrosh <openosd@gmail.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 Jul 2014 12:51:14 -0600
In-Reply-To: <20140723195055.GF6754@linux.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
	 <53CFDBAE.4040601@gmail.com> <20140723195055.GF6754@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 15:50 -0400, Matthew Wilcox wrote:
> On Wed, Jul 23, 2014 at 06:58:38PM +0300, Boaz Harrosh wrote:
> > Have you please pushed this tree to git hub. It used to be on the prd
> > tree, if you could just add another branch there, it would be cool.
> > (https://github.com/01org/prd)
> 
> Ross handles the care & feeding of that tree ... he'll push that branch
> out soon.

I've updated the master branch of PRD's GitHub repo
(https://github.com/01org/prd) so that it is v3.16-rc6 + DAX v8 + PRD.

- Ross



