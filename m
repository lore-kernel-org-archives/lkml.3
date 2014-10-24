Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbaJXLXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:23:38 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:48249 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaJXLXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:23:36 -0400
Message-ID: <1414149810.9509.1.camel@mybabylon.net>
Subject: Re: [PATCH v4 0/7] staging: skein: CryptoAPI and Module Support
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org
Cc: jason@lakedaemon.net, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Oct 2014 06:23:30 -0500
In-Reply-To: <cover.1414149238.git.eric.rost@mybabylon.net>
References: <cover.1414149238.git.eric.rost@mybabylon.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-24 at 06:16 -0500, Eric Rost wrote:
> Adds CryptoAPI and Module support to Skein Hash Algorithm. Also inlines
> rotl_64 macro, and removes nonexistent header references.

This should be [PATCH v5], sorry.

