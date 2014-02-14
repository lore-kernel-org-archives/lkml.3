Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaBNPiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:38:11 -0500
Received: from plane.gmane.org ([80.91.229.3]:44553 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaBNPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:38:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 12/17] Kbuild, lto: Set TMPDIR for LTO
Date: Fri, 14 Feb 2014 07:37:49 -0800
Message-ID: <87a9dtemcy.fsf@tassilo.jf.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
	<1391846481-31491-12-git-send-email-ak@linux.intel.com>
	<52FD9B0A.8030309@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jfdmzpr01-ext.jf.intel.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Cancel-Lock: sha1:NBySk4xn/SdYpr1NWoG7OugKo60=
Cc: linux-kbuild@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> I think this really ought to use ?= so it doesn't override a TMPDIR
> explicitly set by the user.

Done. Thanks.
-andi
-- 
ak@linux.intel.com -- Speaking for myself only

