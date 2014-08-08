Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaHHHmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:42:22 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42111 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaHHHmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:42:19 -0400
Date: Fri, 8 Aug 2014 00:42:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: support.opensource@diasemi.com, anthony.olech.opensource@diasemi.com,
        david.chen@diasemi.com, kiran.padwal21@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: da9055_onkey: convert to use devm_*
Message-ID: <20140808074215.GA10253@core.coreip.homeip.net>
References: <1407482212-17669-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407482212-17669-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kiran,

On Fri, Aug 08, 2014 at 12:46:52PM +0530, Kiran Padwal wrote:
> Converting to devm functions can make the code smaller and cleaner.

Unfortunately it also makes it incorrect. As presented this conversion
introduces race on driver removal. Before doing any more devm conversions
please try to spot it or ping me back in a couple of days if you'd like it
explained.

Thanks.

-- 
Dmitry
