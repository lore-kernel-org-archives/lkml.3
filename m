Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaDSA0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:26:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaDSA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:26:00 -0400
Message-ID: <5351C291.40200@infradead.org>
Date: Fri, 18 Apr 2014 17:25:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ryan Desfosses <ryan@desfo.org>, bhelgaas@google.com
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/8] patch series
References: <1397866610-21328-1-git-send-email-ryan@desfo.org>
In-Reply-To: <1397866610-21328-1-git-send-email-ryan@desfo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 05:16 PM, Ryan Desfosses wrote:
> There are eight patches in this series.  All changes are trivial with no
> dependencies or required order.
> --

My small comments:

a. The Subject should have mentioned PCI and trivial.

b. Please use imperative mood for patch descriptions.  I.e.,

use remove instead of removed;
use move instead of moved;
use merge instead of merged;
use add instead of added.


Don't resend the patches based only on my comments (unless the PCI
maintainer asks you to do so).


thanks,
-- 
~Randy
