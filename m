Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaETQzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:55:35 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:55340 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaETQze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:55:34 -0400
Message-ID: <1400604934.19170.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH V3 mmots] fs/hfsplus/wrapper.c: replace shift loop by
 ilog2
From: Davidlohr Bueso <davidlohr@hp.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Date: Tue, 20 May 2014 09:55:34 -0700
In-Reply-To: <20140520184334.9e903b4965a5776eb0e771e2@skynet.be>
References: <20140520184334.9e903b4965a5776eb0e771e2@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 18:43 +0200, Fabian Frederick wrote:
> Replace while blocksize;shift by ilog2

Fabian, please start getting into the habit of improving your
changelogs. Unlike a lot of OSS projects, the kernel community (usually)
takes pride in having good ones. You send a number of patches but rarely
explain a key concept of software development in general: *WHY* do we
need this.

Thanks,
Davidlohr

