Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162494Ab3DESsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:48:33 -0400
Received: from twosheds.infradead.org ([90.155.92.209]:38206 "EHLO
	twosheds.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162437Ab3DESsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:48:31 -0400
X-Greylist: delayed 3341 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Apr 2013 14:48:31 EDT
Message-ID: <3fedc8674945fdc41d17ecddf82a1dba.squirrel@twosheds.infradead.org>
In-Reply-To: <20130405173133.19936.8383.stgit@phlsvslse11.ph.intel.com>
References: <20130405173133.19936.8383.stgit@phlsvslse11.ph.intel.com>
Date: Fri, 5 Apr 2013 17:52:42 -0000
Subject: Re: [PATCH] firmware,IB/qib: revert firmware file move
From: "David Woodhouse" <dwmw2@infradead.org>
To: "Mike Marciniszyn" <mike.marciniszyn@intel.com>
Cc: roland@purestorage.com, "Dean Luick" <dean.luick@intel.com>,
        linux-rdma@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Vinit Abhay Agnihotri" <vinit.abhay.agnihotri@intel.com>,
        linux-kernel@vger.kernel.org, "David Woodhouse" <dwmw2@infradead.org>
User-Agent: SquirrelMail/1.4.22-10.fc18
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Commit e2eed58 ("IB/qib: change QLogic to Intel") moved a firmware file
> potentially breaking the ABI.
>
> This patch reverts that aspect of the fix as well as reverting the
> firmware name as used in qib.
>
> Reported-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

Thanks. I think there's a one-liner in firmware/Makefile which also needs
to be reverted along with moving the file itself? Other than that,

Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
dwmw2


