Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3IETtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:49:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:55244 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab3IETtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:49:10 -0400
Date: Thu, 5 Sep 2013 15:49:07 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random, Add user configurable get_bytes_random()
Message-ID: <20130905194907.GE23661@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
References: <1378383524-27983-1-git-send-email-prarit@redhat.com>
 <20130905144818.GA23661@thunk.org>
 <52289E6C.8090301@redhat.com>
 <20130905190334.GC23661@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905190334.GC23661@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, note the following article, published today:

http://www.nytimes.com/2013/09/06/us/nsa-foils-much-internet-encryption.html?pagewanted=all

"By this year, the Sigint Enabling Project had found ways inside some
of the encryption chips that scramble information for businesses and
governments, either by working with chipmakers to insert back doors...."

Relying solely and blindly on a magic hardware random number generator
which is sealed inside a CPU chip and which is impossible to audit is
a ***BAD*** idea.

						- Ted
