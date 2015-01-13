Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbbAMPeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:34:00 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:36121 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbAMPd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:33:58 -0500
Date: Tue, 13 Jan 2015 10:33:54 -0500
From: Tejun Heo <tj@kernel.org>
To: James Ralston <james.d.ralston@intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ahci: Remove Device ID for Intel Sunrise Point PCH
Message-ID: <20150113153354.GA3553@htj.dyndns.org>
References: <1421108032-5582-1-git-send-email-james.d.ralston@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421108032-5582-1-git-send-email-james.d.ralston@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 04:13:52PM -0800, James Ralston wrote:
> This patch removes a duplicate AHCI-mode SATA Device ID for the Intel Sunrise Point PCH.
> 
> Signed-off-by: James Ralston <james.d.ralston@intel.com>

Applied to libata/for-3.19-fixes.

Thanks.

-- 
tejun
