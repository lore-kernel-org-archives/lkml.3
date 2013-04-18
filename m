Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049Ab3DRMvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:51:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab3DRMvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:51:06 -0400
Message-ID: <516FEC38.5070407@suse.cz>
Date: Thu, 18 Apr 2013 14:51:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Schweikle <TSchweikle@BfS.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make rpm-pkg fails for all kernels with "spec file not found
 in <kernel>.tar.gz
References: <516F00C8.9070906@BfS.de>
In-Reply-To: <516F00C8.9070906@BfS.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.4.2013 22:06, Thomas Schweikle wrote:
> make O=/home/sct-muc/dev/obj/3.8.8 defconfig
> make O=/home/sct-muc/dev/obj/3.8.8 bzImage
> make O=/home/sct-muc/dev/obj/3.8.8 rpm-pkg

make rpm does not work with O=. There was a bug that it does not detect
this early enough to give a meaningful error message.

Michal

