Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaKGJhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:37:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:58921 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaKGJha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,331,1413270000"; 
   d="scan'208";a="628219894"
Message-ID: <1415353027.958.296.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/2] UBI: Implement UBI_METAONLY
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Murray <amurray@embedded-bits.co.uk>
Date: Fri, 07 Nov 2014 11:37:07 +0200
In-Reply-To: <1414594338-14695-1-git-send-email-richard@nod.at>
References: <1414594338-14695-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 15:52 +0100, Richard Weinberger wrote:
> + * UBI_METAONLY: modify voulme meta data only

Can we please have a bit extended comment for this, explaining what
meta-data is? Like

UBI_METAONLY: modify only the volume meta-data, i.e. the data stored in
              the volume table, but not in any of volume LEBs.


