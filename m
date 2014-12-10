Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaLJEKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 23:10:24 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58742 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaLJEKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 23:10:22 -0500
Date: Tue, 9 Dec 2014 20:10:18 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        dso@cypress.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 00/12] input: cyapa: instruction of cyapa patches
Message-ID: <20141210041018.GD4173@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, dso@cypress.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley, all,

On Tue, Dec 09, 2014 at 05:11:32PM +0800, Dudley Du wrote:
> V13 patches have below updates, details of other updates see history list:
> 1) Remove all debugfs interface, including read_fw and raw_data interfaces.
> 2) This patches are made based linux next-20141208.
> 
[...]

I tested this patch set on an Acer C720 and other than the minor
problems I pointed out in other emails (CONFIG_CYAPA, spelling) it seems
to work fine and there are no obvious problems.

Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>

-- 
- Jeremiah Mahler
