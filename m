Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaKRVOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:14:19 -0500
Received: from 1wt.eu ([62.212.114.60]:53231 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbaKRVOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:14:18 -0500
Date: Tue, 18 Nov 2014 22:14:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] staging: panel: Remove magic numbers
Message-ID: <20141118211411.GD26514@1wt.eu>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com> <1416344174-9155-4-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416344174-9155-4-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 09:56:08PM +0100, Mariusz Gorski wrote:
> Get rid of magic numbers indicating that the value of a module param
> is not set. Use a defined value instead.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>

Acked-by: Willy Tarreau <w@1wt.eu>

