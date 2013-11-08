Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3KHEc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 23:32:29 -0500
Received: from intranet.asianux.com ([58.214.24.6]:52729 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3KHEc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 23:32:28 -0500
X-Spam-Score: -100.8
Message-ID: <527C69DC.80901@asianux.com>
Date: Fri, 08 Nov 2013 12:34:36 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [Consult] Do we need related web site link in "./COPYING" file?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All:

I guess COPYING is our GPL License file, it already contents related
Free Software Foundation address. Do we also need content related web
site link?

When make patch for "arch/arm64/include/uapi/", "scripts/checkpatch.pl"
will report the issue below:

  ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
  #209: FILE: arch/arm64/include/uapi/asm/signal.h:13:
    * You should have received a copy of the GNU General Public License$

I guess, "scrpits/checkpatch.pl" wants to say: "the Linux GPL copy
already contents related web site, so need not 'hard code' them in
another place".


BTW: I find some "^L" in COPYING file, are they for page separation?


Welcome any suggestions or completions.

Thanks.
-- 
Chen Gang
