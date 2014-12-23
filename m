Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbaLWKPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:15:49 -0500
Received: from mail-yk0-f182.google.com ([209.85.160.182]:57786 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbaLWKPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:15:48 -0500
MIME-Version: 1.0
Date: Tue, 23 Dec 2014 15:45:47 +0530
Message-ID: <CAD6G_RRFU_R6SHvc5C785qtJ1GTt_-HXhn83xXOxc=VAwPjdqQ@mail.gmail.com>
Subject: ARM64 Crypto validation
From: Jagan Teki <jagannadh.teki@gmail.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: jteki@apm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need some information to validate arm64/crypto, do we have any
exact/defined way to validate this.

Here are my findings:
1. I see a dirty test module tcrypto.c where we need to give the sec
and mode module params as inputs.
2. Validate through open crypto [1]

Do we have any arm64 specific validations, Request for help.

[1] http://sourceforge.net/projects/ocf-linux/

thanks!
-- 
Jagan.
