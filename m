Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaHKK70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:59:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50021 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaHKK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:59:25 -0400
Date: Mon, 11 Aug 2014 13:58:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Liang Zhen <liang.zhen@intel.com>, linux-kernel@vger.kernel.org,
        Ann Koehler <amk@cray.com>
Subject: Re: [PATCH] staging: lustre: lustre: ptlrpc: nrs.c: Cleaning up
 missing null-terminate after strncpy call
Message-ID: <20140811105837.GO4856@mwanda>
References: <1407628152-24876-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407628152-24876-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 01:49:12AM +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.

No.  This is a problem in the static checker and not in the code.

Look at the start of the function.  This stuff should be obvious for the
static checker.

regards,
dan carpenter

