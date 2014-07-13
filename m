Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaGMKR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 06:17:58 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:54237 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaGMKRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 06:17:49 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Woodhouse <dwmw2@infradead.org>, Rob Landley <rob@landley.net>
Subject: [PATCHv1 0/2] Documentation: move and update headers_install.txt
Date: Sun, 13 Jul 2014 12:15:28 +0200
Message-Id: <cover.1405246007.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <20140709204915.GB32335@ravnborg.org>
References: <1404155479-5638-1-git-send-email-ydroneaud@opteya.com> <53B5C734.9020507@suse.cz> <20140709204915.GB32335@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 22:49 +0200, Sam Ravnborg wrote:
> On Thu, Jul 03, 2014 at 11:12:20PM +0200, Michal Marek wrote:
> > I have never noticed this file :). How about moving it to
> > Documentation/kbuild?
> Agree - please get this file moved.
> 

Please find a patchset to move and update headers_install.txt.

Regards.

Yann Droneaud (2):
  Documentation: headers_install.txt is part of kbuild
  Documentation/kbuild/headers_install.txt: update documentation

 Documentation/kbuild/00-INDEX                      |  2 ++
 Documentation/{make => kbuild}/headers_install.txt | 15 ++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)
 rename Documentation/{make => kbuild}/headers_install.txt (78%)

-- 
1.9.3

