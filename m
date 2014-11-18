Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaKRV0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:26:46 -0500
Received: from 1wt.eu ([62.212.114.60]:53278 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbaKRV0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:26:45 -0500
Date: Tue, 18 Nov 2014 22:26:41 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] staging: panel: Move LCD-related state into struct lcd
Message-ID: <20141118212641.GL26514@1wt.eu>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com> <1416344174-9155-10-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416344174-9155-10-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 09:56:14PM +0100, Mariusz Gorski wrote:
> Move more or less all LCD-related state into struct lcd
> in order to get better cohesion; use bool instead of int
> where it makes sense.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>

Acked-by: Willy Tarreau <w@1wt.eu>

