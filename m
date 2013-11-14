Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3KNRcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:32:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41189 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab3KNRcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:32:25 -0500
Message-ID: <52850900.2080101@zytor.com>
Date: Thu, 14 Nov 2013 09:31:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>,
        Pavel Roskin <proski@gnu.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>
Subject: Re: [PATCH 2/2] x86: Add support for uncompressed kernel images
References: <20131114083247.GB9687@ab42.lan> <1384418296-10374-2-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1384418296-10374-2-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it sounds like we're starting from the beginning - I presume that
means the patch currently in the kernel should be reverted first?

	-hpa

