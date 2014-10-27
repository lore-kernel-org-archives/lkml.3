Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaJ0Jhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:37:34 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46237 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaJ0Jhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:37:32 -0400
Message-ID: <1414402583.16795.3.camel@debian>
Subject: Re: [PATCH 0/2] RAS: add the support for handling UCNA/DEFERRED
 error
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 17:36:23 +0800
In-Reply-To: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
References: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 08:56 +0800, Chen Yucong wrote:

Hi all,

At the suggestion of Boris, the first patch extends the mce_severity
mechanism for handling UCNA/DEFERRED error.
  Link: https://lkml.org/lkml/2014/10/23/190

And on the basis of the first patch, the second patch adds the support
for identifying and handling UCNA/DEFERRED error in machine_check_poll.
 
[PATCH 1/2] x86, mce, severity: extend the the mce_severity
[PATCH 2/2] x86, mce: support memory error recovery for both UCNA

thx!
cyc

