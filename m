Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaEFV2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:28:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:50805 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbaEFV2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:28:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,998,1389772800"; 
   d="scan'208";a="507187668"
Message-ID: <1399411616.2458.45.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH] libata-sff: remove dead code
From: Alan Cox <alan@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 06 May 2014 22:26:56 +0100
In-Reply-To: <1399204229.8729.15.camel@x220>
References: <1399204229.8729.15.camel@x220>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-04 at 13:50 +0200, Paul Bolle wrote:
> Ever since v2.6.19 the code contains a check for CONFIG_NO_ATA_LEGACY.
> But that macro has never been defined. Apparently no one ran into
> problems on platforms that do not support compatibility mode.

It was needed for some of the FRV devices I belive. Please check with
David Howells if it's still relevant (even if its not used in the
default configs)

Alan


