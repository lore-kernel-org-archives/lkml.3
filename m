Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3BMGhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 01:37:12 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:37293 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3BMGhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 01:37:10 -0500
Message-ID: <511B346E.2090900@synopsys.com>
Date: Wed, 13 Feb 2013 12:06:30 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: ksignal changes for 3.9
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

linux-next contains ksignal conversion for some of the architectures. Are you
planning to complete that in 3.9 merge window. The reason I ask is so that the
newer architectures (arc/metag - for a likely 3.9 merge) can queue the
corresponding changes via respective trees.

Thx,
-Vineet
