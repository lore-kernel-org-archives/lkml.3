Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaKJIkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:40:01 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53349 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaKJIkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:40:00 -0500
Date: Mon, 10 Nov 2014 00:39:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: rydberg@euromail.se, Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
 firmware image function support
Message-ID: <20141110083955.GD39688@dtor-ws>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
 <1415003590-30485-16-git-send-email-dudl@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415003590-30485-16-git-send-email-dudl@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:33:07PM +0800, Dudley Du wrote:
> Add read firmware image function supported for gen3 trackpad device,
> it can be used through debugfs read_fw interface.

Why do we need this? Can we do the same via usespace program accessing
the i2c device through /dev/i2c-N?

Thanks.

-- 
Dmitry
