Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3IVVha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:37:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37872 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3IVVh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:37:29 -0400
Date: Sun, 22 Sep 2013 16:37:27 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Why does test_bit() take a volatile addr?
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: torvalds@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <87ioy11k8s.fsf@rustcorp.com.au>
In-Reply-To: <87ioy11k8s.fsf@rustcorp.com.au> (from rusty@rustcorp.com.au on
	Sun Sep 15 23:08:35 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1379885847.1974.45@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2013 11:08:35 PM, Rusty Russell wrote:
> Predates git, does anyone remember the rationale?

Depends which git: http://landley.net/kdocs/fullhist/ :)

Rob