Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaLaQnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 11:43:08 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36218 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaLaQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 11:43:06 -0500
Date: Wed, 31 Dec 2014 17:43:02 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] x86: tools: shell-ify calc_run_size perl-ism
Message-ID: <20141231164302.GA1840@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Choked while compiling linux on a lightweight system, i.e. freed from perl.

New script tested with dash shell and bash shell.

V2:
	- chocked->choked typo
	- early conversion from hexadecimal
	- error messages on stderr

-- 
Sylvain
