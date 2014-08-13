Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaHMKiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:38:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51370 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaHMKis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:38:48 -0400
Date: Wed, 13 Aug 2014 13:38:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Phong Tran <tranmanphong@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        swetland@google.com, linux-kernel@vger.kernel.org, ccross@android.com
Subject: Re: [PATCH 3/5] staging: android: ion: ion_system_heap.c Fix
 checkpatch warning
Message-ID: <20140813103850.GU4856@mwanda>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
 <1407860250-9779-4-git-send-email-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407860250-9779-4-git-send-email-tranmanphong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just fold all these "- return;" patches into one patch.

regards,
dan carpenter

