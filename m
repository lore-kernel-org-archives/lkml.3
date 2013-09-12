Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3ILTPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:15:31 -0400
Received: from longford.logfs.org ([213.229.74.203]:60199 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3ILTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:15:30 -0400
Date: Thu, 12 Sep 2013 13:40:48 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random, Add user configurable get_bytes_random()
Message-ID: <20130912174047.GB3809@logfs.org>
References: <1378383524-27983-1-git-send-email-prarit@redhat.com>
 <20130905144818.GA23661@thunk.org>
 <52289E6C.8090301@redhat.com>
 <20130905190334.GC23661@thunk.org>
 <20130905194907.GE23661@thunk.org>
 <5229C5D4.5070600@redhat.com>
 <20130906135731.GA1249@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130906135731.GA1249@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 September 2013 09:57:31 -0400, Theodore Ts'o wrote:
> according to its specifications.  But a HWRNG is by definition
> something that can't be tested.  Statistical tests are not sufficient
> to prove that the HWRNG has not been gimmicked.

And just to prove your point even more:
http://people.umass.edu/gbecker/BeckerChes13.pdf

Jörn

--
...one more straw can't possibly matter...
-- Kirby Bakken
