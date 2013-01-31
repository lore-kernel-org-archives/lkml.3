Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3AaDoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:44:08 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:59465 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3AaDoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:44:06 -0500
Date: Thu, 31 Jan 2013 11:43:21 +0800
From: yili0568@gmail.com
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: MIPS atomic_set_mask and atomic_clear_mask
Message-ID: <20130131034320.GA15216@gentoo.L3L6.loongson.cn>
Mail-Followup-To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everybody:
     Does MIPS need the functions atomic_set_mask and atomic_clear_mask?
     Or how can I implement these functions.
