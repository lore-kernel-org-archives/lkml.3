Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaCPHoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 03:44:21 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:32910 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaCPHoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 03:44:19 -0400
MIME-Version: 1.0
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 16 Mar 2014 08:43:58 +0100
X-Google-Sender-Auth: p3R_V00yMCa73ZNemDeHjc3jQAg
Message-ID: <CAHO5Pa0Y8r1DxHTc0YN-4geoLJ3JYwHT99EcuaGL6k++ek+aEQ@mail.gmail.com>
Subject: name_to_handle_at() and persistent filesystem IDs
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bruce Fields <bfields@fieldses.org>, linux-man@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Aneesh,

I'm currently working on a man page for name_to_handle_at() and
open_by_handle_at(), and I have a question relating to a point that
probably needs to be covered in the man page.

Back in July 2010, in this thread:
http://thread.gmane.org/gmane.linux.file-systems/41782/focus=43131
you said:

[[
mount id should not be looked at as a persistent identifier. It should
be used to derive a persistent identifier from /proc/self/mountinfo. The
persistent identifier could be the combination of device properties,
file system properties or the uuid which is going to be an optional
tag in /proc/self/mountinfo.
]]

In the man page, I'd like to briefly describe how one derives such a
persistent ID from mountinfo. AFAICS, the optional UUID tag in
/proc/self/mountinfo has not come to pass. So, what then is the
recommended practice for deriving the persistent ID?

Cheers,

Michael

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
