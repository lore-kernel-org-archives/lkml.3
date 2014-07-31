Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaGaFPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:15:15 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54616 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaGaFPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:15:11 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-86-53d9d0dbcdf1
Message-id: <53D9D0DC.9030600@samsung.com>
Date: Thu, 31 Jul 2014 07:15:08 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 RESEND 3/4] drivers: dma-coherent: add initialization
 from device tree
References: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
 <1405326487-15346-4-git-send-email-m.szyprowski@samsung.com>
 <20140729215432.4B73FC40738@trevor.secretlab.ca>
 <53D883AE.6030209@samsung.com>
 <CACxGe6s2G_vEnmo5LwK79bwkEWSNsegfiojDAdQZV01Wapo0eg@mail.gmail.com>
In-reply-to: <CACxGe6s2G_vEnmo5LwK79bwkEWSNsegfiojDAdQZV01Wapo0eg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xq7q3L9wMNlg/T8Nizvo1bBaPX89j
	sfg76Ri7xftlPYwW84+cY7U48GcHo8XK7mY2i53r3jFabO+cwW7x5cpDJotNj6+xWlzeNYfN
	YsPLg0wWC463sFr8mS5nsebIYnaLv9s3sVisn/GaxWLh/PvsFi8/nmBxEPFYM28No8fvX5MY
	PS739TJ57Jx1l92j6+0VJo871/aweZyY8ZvF48GhzSwem5fUe9z+95jZY92fV0we/X8NPObu
	6mP06NuyitHj8ya5AP4oLpuU1JzMstQifbsEroznHXdZC+aFVzxd8YqpgfGkfRcjJ4eEgInE
	/F1bWSBsMYkL99azdTFycQgJLGWUeP9hJyuE84lRYu3WBexdjBwcvAJaEgu++4M0sAioSty8
	e5UdxGYTMJToetvFBmKLCsRInOn9zAxi8woISvyYfA9sgQhQ65M5n8EWMAs8ZZOYse8AI0hC
	WCBe4v7cBSwQyxYxSexrvQSW4BQIljgzcxrYBmYBM4lHLeuYIWx5ic1r3jJPYBSYhWTJLCRl
	s5CULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREslfdzAuPWZ1iFGAg1GJh7fg3ZVg
	IdbEsuLK3EOMEhzMSiK8BxfcDBbiTUmsrEotyo8vKs1JLT7EyMTBKdXAuP/N/8NrD3tqGW0K
	Sy+4/8G4scTkwMNVYd63ahxCljesvZDsG7BC3uTd5BvyNZXPlrVFbdkwYc7jPMZ+ns/O2lVa
	mZujjlz7JtOxcjVnmGfTbKf3Ky4va9tmsdvQO+hm3q7nT06pOldWT+lZn35XZIdkT79K3cZp
	cQr6ycnTlx/23nS1T+FXuRJLcUaioRZzUXEiAMnvAXXCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-31 01:49, Grant Likely wrote:
> On Tue, Jul 29, 2014 at 11:33 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> Hello,
>>
>>
>> On 2014-07-29 23:54, Grant Likely wrote:
>>> On Mon, 14 Jul 2014 10:28:06 +0200, Marek Szyprowski
>>> <m.szyprowski@samsung.com> wrote:
>>>> Initialization procedure of dma coherent pool has been split into two
>>>> parts, so memory pool can now be initialized without assigning to
>>>> particular struct device. Then initialized region can be assigned to
>>>> more than one struct device. To protect from concurent allocations from
>>>> different devices, a spinlock has been added to dma_coherent_mem
>>>> structure. The last part of this patch adds support for handling
>>>> 'shared-dma-pool' reserved-memory device tree nodes.
>>>>
>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> I think this looks okay. It isn't in my area of expertise though.
>>> Comments below.
>>>
>>>> ---
>>>>    drivers/base/dma-coherent.c | 137
>>>> ++++++++++++++++++++++++++++++++++++++------
>>>>    1 file changed, 118 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
>>>> index 7d6e84a51424..7185a4f247e1 100644
>>>> --- a/drivers/base/dma-coherent.c
>>>> +++ b/drivers/base/dma-coherent.c
>>>> @@ -14,11 +14,14 @@ struct dma_coherent_mem {
>>>>          int             size;
>>>>          int             flags;
>>>>          unsigned long   *bitmap;
>>>> +       spinlock_t      spinlock;
>>>>    };
>>>>    -int dma_declare_coherent_memory(struct device *dev, phys_addr_t
>>>> phys_addr,
>>>> -                               dma_addr_t device_addr, size_t size, int
>>>> flags)
>>>> +static int dma_init_coherent_memory(phys_addr_t phys_addr, dma_addr_t
>>>> device_addr,
>>>> +                            size_t size, int flags,
>>>> +                            struct dma_coherent_mem **mem)
>>> This is a bit odd. Why wouldn't you return the dma_mem pointer directly
>>> instead of passing in a **mem argument?
>>
>> Because this function (as a direct successor of dma_declare_coherent_memory)
>> doesn't
>> return typical error codes, but some custom values like DMA_MEMORY_MAP,
>> DMA_MEMORY_IO
>> or zero (which means failure). I wanted to avoid confusion with typical
>> error
>> handling path and IS_ERR/ERR_PTR usage used widely in other functions. This
>> probably
>> should be unified with the rest of kernel some day, but right now I wanted
>> to keep
>> the patch simple and easy to review.
>>
>>
>>>>    {
>>>> +       struct dma_coherent_mem *dma_mem = NULL;
>>>>          void __iomem *mem_base = NULL;
>>>>          int pages = size >> PAGE_SHIFT;
>>>>          int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
>>>> @@ -27,27 +30,26 @@ int dma_declare_coherent_memory(struct device *dev,
>>>> phys_addr_t phys_addr,
>>>>                  goto out;
>>>>          if (!size)
>>>>                  goto out;
>>>> -       if (dev->dma_mem)
>>>> -               goto out;
>>>> -
>>>> -       /* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN
>>>> */
>>>>          mem_base = ioremap(phys_addr, size);
>>>>          if (!mem_base)
>>>>                  goto out;
>>>>    -     dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem),
>>>> GFP_KERNEL);
>>>> -       if (!dev->dma_mem)
>>>> +       dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
>>>> +       if (!dma_mem)
>>>>                  goto out;
>>>> -       dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
>>>> -       if (!dev->dma_mem->bitmap)
>>>> +       dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
>>>> +       if (!dma_mem->bitmap)
>>>>                  goto free1_out;
>>>>    -     dev->dma_mem->virt_base = mem_base;
>>>> -       dev->dma_mem->device_base = device_addr;
>>>> -       dev->dma_mem->pfn_base = PFN_DOWN(phys_addr);
>>>> -       dev->dma_mem->size = pages;
>>>> -       dev->dma_mem->flags = flags;
>>>> +       dma_mem->virt_base = mem_base;
>>>> +       dma_mem->device_base = device_addr;
>>>> +       dma_mem->pfn_base = PFN_DOWN(phys_addr);
>>>> +       dma_mem->size = pages;
>>>> +       dma_mem->flags = flags;
>>>> +       spin_lock_init(&dma_mem->spinlock);
>>>> +
>>>> +       *mem = dma_mem;
>>>>          if (flags & DMA_MEMORY_MAP)
>>>>                  return DMA_MEMORY_MAP;
>>>> @@ -55,12 +57,51 @@ int dma_declare_coherent_memory(struct device *dev,
>>>> phys_addr_t phys_addr,
>>>>          return DMA_MEMORY_IO;
>>>>       free1_out:
>>>> -       kfree(dev->dma_mem);
>>>> +       kfree(dma_mem);
>>>>     out:
>>>>          if (mem_base)
>>>>                  iounmap(mem_base);
>>>>          return 0;
>>>>    }
>>>> +
>>>> +static void dma_release_coherent_memory(struct dma_coherent_mem *mem)
>>>> +{
>>>> +       if (!mem)
>>>> +               return;
>>>> +       iounmap(mem->virt_base);
>>>> +       kfree(mem->bitmap);
>>>> +       kfree(mem);
>>>> +}
>>>> +
>>>> +static int dma_assign_coherent_memory(struct device *dev,
>>>> +                                     struct dma_coherent_mem *mem)
>>>> +{
>>>> +       if (dev->dma_mem)
>>>> +               return -EBUSY;
>>>> +
>>>> +       dev->dma_mem = mem;
>>>> +       /* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN
>>>> */
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +int dma_declare_coherent_memory(struct device *dev, phys_addr_t
>>>> phys_addr,
>>>> +                               dma_addr_t device_addr, size_t size, int
>>>> flags)
>>>> +{
>>>> +       struct dma_coherent_mem *mem;
>>>> +       int ret;
>>>> +
>>>> +       ret = dma_init_coherent_memory(phys_addr, device_addr, size,
>>>> flags,
>>>> +                                      &mem);
>>>> +       if (ret == 0)
>>>> +               return 0;
>>>> +
>>>> +       if (dma_assign_coherent_memory(dev, mem) == 0)
>>>> +               return ret;
>>>> +
>>>> +       dma_release_coherent_memory(mem);
>>>> +       return 0;
>>>> +}
>>>>    EXPORT_SYMBOL(dma_declare_coherent_memory);
>>>>      void dma_release_declared_memory(struct device *dev)
>>>> @@ -69,10 +110,8 @@ void dma_release_declared_memory(struct device *dev)
>>>>          if (!mem)
>>>>                  return;
>>>> +       dma_release_coherent_memory(mem);
>>>>          dev->dma_mem = NULL;
>>>> -       iounmap(mem->virt_base);
>>>> -       kfree(mem->bitmap);
>>>> -       kfree(mem);
>>>>    }
>>>>    EXPORT_SYMBOL(dma_release_declared_memory);
>>>>    @@ -80,6 +119,7 @@ void *dma_mark_declared_memory_occupied(struct
>>>> device *dev,
>>>>                                          dma_addr_t device_addr, size_t
>>>> size)
>>>>    {
>>>>          struct dma_coherent_mem *mem = dev->dma_mem;
>>>> +       unsigned long flags;
>>>>          int pos, err;
>>>>          size += device_addr & ~PAGE_MASK;
>>>> @@ -87,8 +127,11 @@ void *dma_mark_declared_memory_occupied(struct device
>>>> *dev,
>>>>          if (!mem)
>>>>                  return ERR_PTR(-EINVAL);
>>>>    +     spin_lock_irqsave(&mem->spinlock, flags);
>>>>          pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
>>>>          err = bitmap_allocate_region(mem->bitmap, pos, get_order(size));
>>>> +       spin_unlock_irqrestore(&mem->spinlock, flags);
>>>> +
>>>>          if (err != 0)
>>>>                  return ERR_PTR(err);
>>>>          return mem->virt_base + (pos << PAGE_SHIFT);
>>>> @@ -115,6 +158,7 @@ int dma_alloc_from_coherent(struct device *dev,
>>>> ssize_t size,
>>>>    {
>>>>          struct dma_coherent_mem *mem;
>>>>          int order = get_order(size);
>>>> +       unsigned long flags;
>>>>          int pageno;
>>>>          if (!dev)
>>>> @@ -124,6 +168,7 @@ int dma_alloc_from_coherent(struct device *dev,
>>>> ssize_t size,
>>>>                  return 0;
>>>>          *ret = NULL;
>>>> +       spin_lock_irqsave(&mem->spinlock, flags);
>>>>          if (unlikely(size > (mem->size << PAGE_SHIFT)))
>>>>                  goto err;
>>>> @@ -138,10 +183,12 @@ int dma_alloc_from_coherent(struct device *dev,
>>>> ssize_t size,
>>>>          *dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
>>>>          *ret = mem->virt_base + (pageno << PAGE_SHIFT);
>>>>          memset(*ret, 0, size);
>>>> +       spin_unlock_irqrestore(&mem->spinlock, flags);
>>>>          return 1;
>>>>      err:
>>>> +       spin_unlock_irqrestore(&mem->spinlock, flags);
>>>>          /*
>>>>           * In the case where the allocation can not be satisfied from the
>>>>           * per-device area, try to fall back to generic memory if the
>>>> @@ -171,8 +218,11 @@ int dma_release_from_coherent(struct device *dev,
>>>> int order, void *vaddr)
>>>>          if (mem && vaddr >= mem->virt_base && vaddr <
>>>>                     (mem->virt_base + (mem->size << PAGE_SHIFT))) {
>>>>                  int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
>>>> +               unsigned long flags;
>>>>    +             spin_lock_irqsave(&mem->spinlock, flags);
>>>>                  bitmap_release_region(mem->bitmap, page, order);
>>>> +               spin_unlock_irqrestore(&mem->spinlock, flags);
>>>>                  return 1;
>>>>          }
>>>>          return 0;
>>>> @@ -218,3 +268,52 @@ int dma_mmap_from_coherent(struct device *dev,
>>>> struct vm_area_struct *vma,
>>>>          return 0;
>>>>    }
>>>>    EXPORT_SYMBOL(dma_mmap_from_coherent);
>>>> +
>>>> +/*
>>>> + * Support for reserved memory regions defined in device tree
>>>> + */
>>>> +#ifdef CONFIG_OF_RESERVED_MEM
>>>> +#include <linux/of.h>
>>>> +#include <linux/of_fdt.h>
>>>> +#include <linux/of_reserved_mem.h>
>>>> +
>>>> +static void rmem_dma_device_init(struct reserved_mem *rmem, struct
>>>> device *dev)
>>>> +{
>>>> +       struct dma_coherent_mem *mem = rmem->priv;
>>> Will the reserved_mem->priv pointer ever point to some other kind of
>>> structure? How do we know that the pointer here is always a
>>> dma_coherent_mem struct (if there are other uses of priv, what is the
>>> guarantee against another user assigning something to it?) Is it the
>>> reserved_mem_ops below that provide the guarantee?
>>
>> reserved_mem_ops are set by the given reserved memory driver and access to
>> priv
>> pointer is limited only to that driver. This pattern is used widely across
>> the
>> whole kernel, so I don't think that a separate pointer to particular
>> structure
>> type is needed.
> Yup, that's fine. I wanted to make sure.
>
> Do I need to be taking these patches through the DT tree? Do patches 3
> & 4 make sense without patch 2?

Patches 3 and 4 are independent from patch 1&2. Patch 4 depends on the 
other CMA
patches, which has been merged to akpm tree. I think the easiest 
solution would
be to get your Ack for both patches and I will ask Andrew Morton to take 
them
together with other mm/CMA changes.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

