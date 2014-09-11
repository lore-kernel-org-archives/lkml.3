Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaIKWtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:49:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaIKWtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:49:08 -0400
Date: Thu, 11 Sep 2014 15:49:06 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] toshiba_acpi: Change touchpad store to check for
 invalid values
Message-ID: <20140911224906.GC18425@vmdeb7>
References: <1410404517-4209-1-git-send-email-coproscefalo@gmail.com>
 <1410404517-4209-2-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410404517-4209-2-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:01:57PM -0600, Azael Avalos wrote:
> The function toshiba_touchpad_store is not checking
> for invalid values and simply returns silently.
> 
> This patch checks for invalid values and returns accordingly.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>

Queued, thanks Azael!

-- 
Darren Hart
Intel Open Source Technology Center
