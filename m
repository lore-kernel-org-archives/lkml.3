Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaEOKsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:48:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49161 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaEOKsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:48:37 -0400
Message-ID: <53749855.4050906@ahsoftware.de>
Date: Thu, 15 May 2014 12:35:01 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Rename EPROBE_DEFER to ENOTHING_TO_SEE_WE_SOLVE_EVERYTHING_LATER
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe in verbose names, therefor

find linux.git/ -name '*.[c|h]' -exec sed 
s/EPROBE_DEFER/ENOTHING_TO_SEE_WE_SOLVE_EVERYTHING_LATER/g -i {} 
2>/dev/null \;

142 files changed, 261 insertions(+), 261 deletions(-)

Tested!

And how do deferred probes handle cycles?

I suggest to make squares out of them.

Convinced? ;)

Alexander Holler

PS: And no, I don't throw chairs around. I just think sometimes a joke 
is a good thing.
