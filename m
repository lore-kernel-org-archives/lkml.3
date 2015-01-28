Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbbA1ULk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:11:40 -0500
Received: from tex.lwn.net ([70.33.254.29]:35192 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbA1UKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:10:50 -0500
Date: Wed, 28 Jan 2015 12:17:09 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Julian Brost <linux-kernel@0x4a42.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        tomas.winkler@intel.com, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
Subject: Re: [PATCH 1/4] Documentation/misc-devices/mei: Fix formatting of
 headings.
Message-ID: <20150128121709.5b6afb11@lwn.net>
In-Reply-To: <1421020689-28332-2-git-send-email-linux-kernel@0x4a42.net>
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
	<1421020689-28332-2-git-send-email-linux-kernel@0x4a42.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 00:58:06 +0100
Julian Brost <linux-kernel@0x4a42.net> wrote:

> Make the heading underlines fit the length of the heading, remove colons
> at the end of headings and consistently place an empty line after each
> heading and two empty lines before each that is preceded by a paragraph.
> 
> Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
> Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>

[Finally catching up with stuff after a long travel]

These changes look fine, but what's with the two signoffs?  Who is the
actual author of these patches, and why is the second signoff there?

Thanks,

jon
