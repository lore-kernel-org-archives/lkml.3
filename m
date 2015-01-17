Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbbAQWqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:46:25 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33048 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbAQWqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:46:24 -0500
Date: Sat, 17 Jan 2015 14:46:20 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: David Solda <dso@cypress.com>
Cc: Dudley Du <dudl@cypress.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Message-ID: <20150117224620.GA2855@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	David Solda <dso@cypress.com>, Dudley Du <dudl@cypress.com>,
	"dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
	"rydberg@euromail.se" <rydberg@euromail.se>,
	"bleung@google.com" <bleung@google.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <20150117104415.GA2083@hudson.localdomain>
 <0F1DD2F3-F620-4161-A406-43C8F56A1304@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F1DD2F3-F620-4161-A406-43C8F56A1304@cypress.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Sat, Jan 17, 2015 at 06:00:29PM +0000, David Solda wrote:
> Can we just reverse the prior change that caused the bug, or are you saying that the owner of the prior patch has to fix it?
> 
> Dave
> 

I tried to revert the patch but it didn't do so cleanly.

  git revert ea2c67bb4aff

So I just reverted back to next-20150112.

  git reset --hard next-20150112

I hope the owner of the prior patch responds promptly and fixes their
bug.  But for the time being the cyapa patch series works when that
other bug is avoided.

If you have any suggestions, let me know.

-- 
- Jeremiah Mahler
