Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaKSVL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:11:58 -0500
Received: from 1wt.eu ([62.212.114.60]:55778 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbaKSVLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:11:55 -0500
Date: Wed, 19 Nov 2014 22:11:50 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/9] staging: panel: Remove more magic number comparison
Message-ID: <20141119211150.GG30756@1wt.eu>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com> <1416429531-11088-9-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416429531-11088-9-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:38:50PM +0100, Mariusz Gorski wrote:
> Use a defined value instead of magic number comparison
> for checking whether a module param value has been set.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>

Acked-by: Willy Tarreau <w@1wt.eu>
