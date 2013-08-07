Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab3HGLhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:37:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65140 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3HGLhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:37:22 -0400
X-AuditID: cbfee68e-b7f276d000002279-1a-520231703b0d
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1375875416.22638.51.camel@kjgkr>
Subject: Re: [RFC 0/5] Enable f2fs support inline data
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: Haicheng Li <haicheng.li@linux.intel.com>,
        Namjae Jeon <linkinjeon@gmail.com>, Huajun Li <huajun.li@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, namjae.jeon@samsung.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>
Date: Wed, 07 Aug 2013 20:36:56 +0900
In-reply-to: <CA+v9cxZVvW+puuSWOYPJ-QnMPq-=vSi3xbb79s1u8i43XN2Wxw@mail.gmail.com>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
 <1370312366.3600.3.camel@kjgkr>
 <CAKYAXd-87rGatnEC8wbocR_wt6Qdpec3HzZaH9ukpzmst6DK=A@mail.gmail.com>
 <20130604060119.GA3265@hli22-desktop> <1370416414.3600.36.camel@kjgkr>
 <CA+v9cxZVvW+puuSWOYPJ-QnMPq-=vSi3xbb79s1u8i43XN2Wxw@mail.gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zY90CQ6Yggx9fVC1eHtK0OPOsg9Fi
	y5YYi6/9d9gsrt+9xWxxaZG7xZ69J1ksLu+aw2bxY3q9A6fHzll32T0W73nJ5DHvZKDH7gWf
	mTz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoErY/OGeYwFO+0qzhx7w9TAeE6ti5GTQ0LARKJl
	3jpWCFtM4sK99WxdjFwcQgLLGCUOPelgginaOfcJE0RiEaPEsx9z2UASvAKCEj8m32MBsZkF
	1CUmzVvEDGGLSFzaO4kdwtaWWLbwNVhcSOA1o8S5wy4QvboSF9ZeYOxi5OAQFjCTaOnPAjHZ
	gMo37zeAqFaUeLv/LthtIkDTX7+YywpyArPAKiaJnV+6wUayCKhKbPjcCFbEKRAscWTLS6g7
	9zBJ/Hn/DewBfgFRicMLtzNDPKMksbu9kx2kSEKgkUPi+qQjUJMEJL5NPsQCcoWEgKzEpgNQ
	9ZISB1fcYJnAKDkLycuzkLw8C8nLs5C8vICRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZG
	SKz37WC8ecD6EGMy0PqJzFKiyfnAVJFXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBsZVs31ibb+s/zXzGdf3jESTb9nft2ZeczBWPDF389r2jDnn
	XP50lgmwnzqwjY/t8tSvzyLbFb6yh/MrndxorPf98nRX33XKE/trXpa8vbfUWKHar+aUW6bT
	sz3GBxmkdt8KL7haaXzmd6sa+xE/LoadeeFqaZu9Q55Ok1JQvvRv4XP5w+9D4vKUWIozEg21
	mIuKEwHBd0o5CwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAd0CQ6Yggyc/5C1eHtK0OPOsg9Fi
	y5YYi6/9d9gsrt+9xWxxaZG7xZ69J1ksLu+aw2bxY3q9A6fHzll32T0W73nJ5DHvZKDH7gWf
	mTz6tqxi9Pi8SS6ALaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8b1R/uZ
	CqbaVaz8N5m9gXGVWhcjJ4eEgInEzrlPmCBsMYkL99azdTFycQgJLGKUePZjLhtIgldAUOLH
	5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvEDGILCbxmlDh32AWiXFfiwtoLjCDlwgJmEi39WSAm
	m4C2xOb9BhDVihJv999lBbFFgKa8fjGXFWQrs8AqJomdX7rBRrIIqEps+NwIVsQpECxxZMtL
	JojT9jBJ/Hn/DexmfgFRicMLtzND3K8ksbu9k30Co9AsJFfPQrh6FpKrFzAyr2IUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQITgrPpHcwrmqwOMQowMGoxMNbIcYYJMSaWFZcmXuIUYKDWUmE
	dwIrU5AQb0piZVVqUX58UWlOavEhxmSgyycyS4km5wMTVl5JvKGxiZmRpZGZhZGJuTlpwkri
	vAdbrQOFBNITS1KzU1MLUotgtjBxcEo1ME7cZRrb5LGx8JV10y+79jAjse+Rq1af2hRy5FTB
	55fzjL/mlX9riz3fU8f9Z9GEC3usCj74FWYovffPDVh/RNznUP7xWh27Jy9zp++dJi15fsPk
	M03vXp9Z4t5vKfbZl+dowJPtC/cxVlzqll22e2JXkGvCouJZqzapSRzMW2Lwc2H3YrlTxeuU
	WIozEg21mIuKEwEW7G2oTgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huajun,

Sorry for the long delay.
I've been too busy to catch up this new big feature.

Anyway, do you guys still design or focus on this issue?
Nowadays, I can afford to dive into this issue.
So, if you have done any progress so far, can you share it with me?
Otherwise, I'd like to start to design it from the scatch.

Thanks,

2013-06-08, 15:25 +0800, Huajun Li:
> 
> Hi Jaegeuk, 
> Thanks for your suggestion.
> 
> 
> On Wed, Jun 5, 2013 at 3:13 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com>
> wrote:
>         Hi Haicheng,
>         
>         2013-06-04 (화), 14:01 +0800, Haicheng Li:
>         > Hi Jaegeuk & Namjae,
>         >
>         > Sure, we'll address your comments. And this version is RFC,
>         just wanna to
>         > make sure this feature is meaningful for f2fs project, and
>         there is no obvious
>         > mistake, e.g. missing some critical path.
>         
>         
>         IMO, it is worth to design and implement the inline feature
>         though, I'd
>         like to review the total design before looking at trivial
>         mistakes.
>         Since if the initial design is changed frequently, we need to
>         review
>         again and again.
>         
> Agree. So let's understand/clarify your following proposal firstly.
> 
> 
>         So, we need to decide the overall inline design.
>         Currently we have to consider three data structures at a same
>         time for
>         the on-disk *inline* inode block structure, which are data,
>         dentry, and
>         xattr as well.
>         
>         IMO, we can give three inode flags: F2FS_INLINE_DATA,
>         F2FS_INLINE_DENT,
>         and F2FS_INLINE_XATTR.
>         
> Small data and dentries can be inline.  And xattr (such as XATTR_USER,
> XATTR_TRUSTED, eg. ) can be inline too, right ?
> Or inline xattr is just working for inline data/dentries?
>  
>         < on-disk inode block >
>          - metadata
>          - if F2FS_INLINE_XATTR is set,
>           : use fixed 2*255 bytes to *cache* two xattrs for simplicity
> 
> These 2 xattrs are working for the ones storing in xattr_nid block
> before, or just providing info for inline data/dent ? 
> 
> 
>          `- if F2FS_INLINE_DATA is set,
>            : use the remained space varied by F2FS_INLINE_XATTR.
>          `- if F2FS_INLINE_DENT is set,
>            : use variable number of dentries determined by
>         F2FS_INLINE_XATTR.
> Do you mean inline dent depends on inline xattr, that is, we need a
> dedicated xattr entry providing info for inline denteries, right?
>  
> 
>          `- Otherwise, use as pointers
>         
>         And then, we need to define how to deal with their
>         combinations.
>         
>         Operational conditions
>         ----------------------
>          - use inline xattr or not, by checking other inline flags and
>         inline
>         data size.
>          - calculate inline data size and its offset according to the
>         use of
>         inline xattrs.
>          - the places of inline operaions wrt the lock consistency and
>         coverage
>          - Power-off-recovery routine should care about the on-disk
>         inode
>         structure.
>          - unset F2FS_INLINE_DATA if i_size = 0
>          - unset F2FS_INLINE_XATTR if xattr entries = 0
>          - unset F2FS_INLINE_DENT if dentries = 0
>         
>          - what else?
> - clear these flags after the inline data/dent is moved to normal data
> block
> - maybe we need store xattr_header while making xattr inline. 
> 
> 
>         
>         Once we design the whole thing, we can make general functions
>         to deal
>         with them gracefully.
>         
>         > And if you team has some special opensource test suites used
>         in your daily
>         > f2fs test cycle, pls. kindly share the info with us, then we
>         can make sure our
>         > patchset can pass these cases before we send out next
>         version.
>         
>         
>         1. xfstests for functionality
>         2. fsstress for deadlock/consistency check
>         3. power-off with fsstress
>         
>         Thanks,
>         
>         > BTW, test the kernel source tree or kernel build is a good
>         suggestion. thanks.
>         >
>         > On Tue, Jun 04, 2013 at 01:23:57PM +0900, Namjae Jeon wrote:
>         > > Hi. Huajun.
>         > >
>         > > I agree jaegeuk's opinion.
>         > > Additionally, It is better that you describe the effect in
>         change-log
>         > > when this feature is added to f2fs.
>         > > e.g.
>         > >     1. how much space is saved when storing
>         kernel-tree(small files) ?
>         > >     2. small files creation performance test.
>         > >     3. file look-up performance test.
>         > >     4. other performance tools 's result.
>         > >
>         > > Thanks.
>         > >
>         > > 2013/6/4 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>         > > > Hi,
>         > > >
>         > > > This feature is one of my todo items. ;)
>         > > > Thank you for the contribution.
>         > > >
>         > > > Before reviewing the below code intensively, we need to
>         check the
>         > > > following issues.
>         > > >
>         > > > - deadlock conditions
>         > > > - FS consistency
>         > > > - recovery routine
>         > > >
>         > > > Could you check one more time?
>         > > > Thanks again,
>         > > >
>         > > > 2013-06-03 (월), 18:04 +0800, Huajun Li:
>         > > >> f2fs inode is so large, small files can be stored
>         directly in the inode,
>         > > >> rather than just storing a single block address and
>         storing the data elsewhere.
>         > > >>
>         > > >> This RFC patch set is just to enable f2fs support
>         inline data: files less than
>         > > >> about 3.6K can be stored directly in inode block.
>         > > >>
>         > > >> TODO: make small dirs inline too.
>         > > >>
>         > > >>
>         > > >> Haicheng Li (3):
>         > > >>   f2fs: Add helper functions and flag to support inline
>         data
>         > > >>   f2fs: Add interface for inline data support
>         > > >>   f2fs: add tracepoints to debug inline data operations
>         > > >>
>         > > >> Huajun Li (2):
>         > > >>   f2fs: Handle inline data read and write
>         > > >>   f2fs: Key functions to handle inline data
>         > > >>
>         > > >>  fs/f2fs/Kconfig             |   10 +++
>         > > >>  fs/f2fs/Makefile            |    1 +
>         > > >>  fs/f2fs/data.c              |   78
>         +++++++++++++++++++++-
>         > > >>  fs/f2fs/f2fs.h              |   70 +++++++++++++++++++
>         > > >>  fs/f2fs/file.c              |    9 ++-
>         > > >>  fs/f2fs/inline.c            |  156
>         +++++++++++++++++++++++++++++++++++++++++++
>         > > >>  fs/f2fs/inode.c             |    8 +++
>         > > >>  include/linux/f2fs_fs.h     |    5 ++
>         > > >>  include/trace/events/f2fs.h |   69 +++++++++++++++++++
>         > > >>  9 files changed, 402 insertions(+), 4 deletions(-)
>         > > >>  create mode 100644 fs/f2fs/inline.c
>         > > >>
>         > > >
>         > > > --
>         > > > Jaegeuk Kim
>         > > > Samsung
>         > > --
>         > > To unsubscribe from this list: send the line "unsubscribe
>         linux-fsdevel" in
>         > > the body of a message to majordomo@vger.kernel.org
>         > > More majordomo info at
>          http://vger.kernel.org/majordomo-info.html
>         
>         
>         --
>         Jaegeuk Kim
>         Samsung
> 
> 

-- 
Jaegeuk Kim
Samsung

