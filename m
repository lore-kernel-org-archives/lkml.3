Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbaKSVLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:11:23 -0500
Received: from 1wt.eu ([62.212.114.60]:55769 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbaKSVLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:11:21 -0500
Date: Wed, 19 Nov 2014 22:11:16 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] staging: panel: Make two more module params read-only
Message-ID: <20141119211116.GE30756@1wt.eu>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com> <1416429531-11088-7-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416429531-11088-7-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:38:48PM +0100, Mariusz Gorski wrote:
> Make keypad_type and lcd_type module params read-only.
> This step also starts making it more clear what is
> the precedence of device params coming from different
> sources (device profile, runtime module param values etc).
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>

Acked-by: Willy Tarreau <w@1wt.eu>

